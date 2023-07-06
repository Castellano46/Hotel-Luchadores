struct Client {
    let name: String
    let age: Int
    let height: Double
}

struct Reservation {
    let id: Int
    let hotelName: String
    let clients: [Client]
    let duration: Int
    let breakfastOption: Bool
    let price: Double
}

enum ReservationError: Error {
    case duplicateID
    case duplicateClient
    case reservationNotFound
}

class HotelReservationManager {
    private var reservations: [Reservation] = []
    private var reservationIDCounter: Int = 1
    
    func addReservation(clients: [Client], duration: Int, breakfastOption: Bool) throws -> Reservation {
        for client in clients {
            assert(!isClientAlreadyBooked(client), "Client is already booked in another reservation.")
        }
        
        let reservationID = reservationIDCounter
        reservationIDCounter += 1
        
        let price = Double(clients.count) * 20 * Double(duration) * (breakfastOption ? 1.25 : 1)
        
        assert(!isReservationIDAlreadyUsed(reservationID), "Reservation ID is already used.")
        
        let reservation = Reservation(id: reservationID, hotelName: "Hotel Luchadores", clients: clients, duration: duration, breakfastOption: breakfastOption, price: price)
        
        reservations.append(reservation)
        
        return reservation
    }
    
    func cancelReservation(withID id: Int) throws {
        guard let index = reservations.firstIndex(where: { $0.id == id }) else {
            throw ReservationError.reservationNotFound
        }
        
        reservations.remove(at: index)
    }
    
    func getAllReservations() -> [Reservation] {
        return reservations
    }
    
    private func isReservationIDAlreadyUsed(_ id: Int) -> Bool {
        for reservation in reservations {
            if reservation.id == id {
                return true
            }
        }
        return false
    }
    
    private func isClientAlreadyBooked(_ client: Client) -> Bool {
        for reservation in reservations {
            for bookedClient in reservation.clients {
                if bookedClient.name == client.name {
                    return true
                }
            }
        }
        return false
    }
}

func testAddReservation() {
    let manager = HotelReservationManager()
    
    let client1 = Client(name: "Goku", age: 44, height: 175)
    let client2 = Client(name: "Piccolo", age: 27, height: 236)
    let client3 = Client(name: "Vegeta", age: 48, height: 165)
    let client4 = Client(name: "Freezer", age: 70, height: 158)
    
    var reservation1: Reservation!
    var reservation2: Reservation!
    var reservation3: Reservation!
    
    var error: Error?
    
    while reservation1 == nil {
        do {
            reservation1 = try manager.addReservation(clients: [client1, client2], duration: 3, breakfastOption: true)
            print("Reservation added:", reservation1!)
        } catch let reservationError as ReservationError {
            switch reservationError {
            case .duplicateClient:
                assertionFailure("Client is already booked in another reservation.")
            case .duplicateID:
                assertionFailure("Reservation ID is already used.")
            default:
                break
            }
        } catch let err{
            error = err
        }
    }
    
    while reservation2 == nil {
        do {
            reservation2 = try manager.addReservation(clients: [client3], duration: 5, breakfastOption: false)
            print("Reservation added:", reservation2!)
        } catch let reservationError as ReservationError {
            switch reservationError {
            case .duplicateClient:
                assertionFailure("Client is already booked in another reservation.")
            case .duplicateID:
                assertionFailure("Reservation ID is already used.")
            default:
                break
            }
        } catch let err{
            error = err
        }
    }
    
    while reservation3 == nil {
        do {
            reservation3 = try manager.addReservation(clients: [client4], duration: 2, breakfastOption: true)
            print("Reservation added:", reservation3!)
        } catch let reservationError as ReservationError {
            switch reservationError {
            case .duplicateClient:
                assertionFailure("Client is already booked in another reservation.")
            case .duplicateID:
                assertionFailure("Reservation ID is already used.")
            default:
                break
            }
        } catch let err {
            error = err
        }
    }
    
    assert(error == nil, "Error occurred while adding reservation.")
}

func testCancelReservation() {
    let manager = HotelReservationManager()
    
    let client1 = Client(name: "Goku", age: 44, height: 175)
    let client2 = Client(name: "Piccolo", age: 27, height: 236)
    let client3 = Client(name: "Vegeta", age: 48, height: 165)
    let client4 = Client(name: "Freezer", age: 70, height: 158)
    
    var reservation: Reservation?
    var error: Error?
    
    while reservation == nil {
        do {
            reservation = try manager.addReservation(clients: [client1, client2, client3, client4], duration: 3, breakfastOption: true)
            print("Reservation added:", reservation!)
        } catch let reservationError as ReservationError {
            switch reservationError {
            case .duplicateClient:
                assertionFailure("Client is already booked in another reservation.")
            case .duplicateID:
                assertionFailure("Reservation ID is already used.")
            default:
                break
            }
        } catch let err{
            error = err
        }
    }
    
    while reservation != nil {
        do {
            try manager.cancelReservation(withID: reservation!.id)
            print("Reservation cancelled")
            reservation = nil
        } catch let reservationError as ReservationError {
            switch reservationError {
            case .reservationNotFound:
                assertionFailure("Reservation not found.")
            default:
                break
            }
        } catch let err{
            error = err
        }
    }
    
    assert(error == nil, "Error occurred while cancelling reservation.")
}

func testReservationPrice() {
    let manager = HotelReservationManager()
    
    let client1 = Client(name: "Goku", age: 44, height: 175)
    let client2 = Client(name: "Piccolo", age: 27, height: 236)
    let client3 = Client(name: "Vegeta", age: 48, height: 165)
    let client4 = Client(name: "Freezer", age: 70, height: 158)
    
    var reservation1: Reservation!
    var reservation2: Reservation!
    var reservation3: Reservation!
    var reservation4: Reservation!
    
    var error: Error?
    
    while reservation1 == nil {
        do {
            reservation1 = try manager.addReservation(clients: [client1], duration: 3, breakfastOption: true)
            print("Reservation added:", reservation1!)
        } catch let reservationError as ReservationError {
            switch reservationError {
            case .duplicateClient:
                assertionFailure("Client is already booked in another reservation.")
            case .duplicateID:
                assertionFailure("Reservation ID is already used.")
            default:
                break
            }
        } catch let err{
            error = err
        }
    }
    
    while reservation2 == nil {
        do {
            reservation2 = try manager.addReservation(clients: [client2], duration: 3, breakfastOption: true)
            print("Reservation added:", reservation2!)
        } catch let reservationError as ReservationError {
            switch reservationError {
            case .duplicateClient:
                assertionFailure("Client is already booked in another reservation.")
            case .duplicateID:
                assertionFailure("Reservation ID is already used.")
            default:
                break
            }
        } catch let err{
            error = err
        }
    }
    
    while reservation3 == nil {
        do {
            reservation3 = try manager.addReservation(clients: [client1, client2], duration: 3, breakfastOption: true)
            print("Reservation added:", reservation3!)
        } catch let reservationError as ReservationError {
            switch reservationError {
            case .duplicateClient:
                assertionFailure("Client is already booked in another reservation.")
            case .duplicateID:
                assertionFailure("Reservation ID is already used.")
            default:
                break
            }
        } catch let err{
            error = err
        }
    }
    
    while reservation4 == nil {
        do {
            reservation4 = try manager.addReservation(clients: [client1, client2], duration: 3, breakfastOption: false)
            print("Reservation added:", reservation4!)
        } catch let reservationError as ReservationError {
            switch reservationError {
            case .duplicateClient:
                assertionFailure("Client is already booked in another reservation.")
            case .duplicateID:
                assertionFailure("Reservation ID is already used.")
            default:
                break
            }
        } catch let err{
            error = err
        }
    }
    
    assert(error == nil, "Error occurred while adding reservation.")
    assert(reservation1.price == reservation3.price, "Prices should be equal.")
}

// Run the tests
testAddReservation()
testCancelReservation()
testReservationPrice()


