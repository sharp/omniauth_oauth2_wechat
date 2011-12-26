#include <ctime>
#include <iostream>
#include <string>
#include <boost/asio.hpp>

using boost::asio::ip::tcp;

std::string make_time(){
  using namespace std;
  time_t now = time(0);
  return ctime(&now);
}

int main(){
  try{
    boost::asio::io_service io_service;
    tcp::acceptor acceptor(io_service, tcp::endpoint(tcp::v4(), 4000));
    for(;;){
      tcp::socket socket(io_service);
      acceptor.accept(socket);
      std::string message = nake_time();
      boost::system::error_code error;
      boost::asio::write(socket, boost::asio::buffer(message), error);
    }    
  }
  catch(std::exception& e){
    std::cerr << e.what() << std::endl
  }
  return 0;
}
