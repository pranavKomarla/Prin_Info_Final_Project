import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class ReservationServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Call the make_reservation method
        make_reservation();

        // Redirect or forward after reservation
        request.setAttribute("message", "Reservation successful!");
        RequestDispatcher dispatcher = request.getRequestDispatcher("index.jsp");
        dispatcher.forward(request, response);
    }

    private void make_reservation() {
        // Your reservation logic here
        System.out.println("Reservation made successfully!");
    }
}
