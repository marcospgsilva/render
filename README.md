# Render
<b>Liveview re-rendering, PartitionSupervisor, DynamicSupervisor, GenServer and fult-tolerant</b> experiment. 

![render](https://user-images.githubusercontent.com/19523657/213333214-7e08856d-7d0e-4258-91a2-20dc73934519.gif)

# How does it works?
Each Particle is a <b>GenServer</b> under a <b>DynamicSupervisor</b>.
You can start 1, 2, 5 or 10 Particles(GenServer) at once and the <b>PartitionSupervisor</b> will be responsible to define under which <b>DynamicSupervisor</b> the child must be appended. <b>PartitionSupervisor</b> avoids bottlenecks caused by too slow `init/1` functions in a <b>GenServer</b>.

Each GenServer initiates their Particle position randomly and in the <b>down</b> direction(From TOP to BOTTOM), every 60 milliseconds their positions are updated respecting the current `:direction`.

On our LiveView side, we have a Live connection responsible for getting Particles from PartitionSupervisor and render each particle, again, every 60 milliseconds. 
Each Particle has their own state, it means they can move in different sides once their state is not shared between others.
Also, is possible to <b>kill</b> each Particle <b>without any side effect<b> in the others.
That's exactly the idea behind <b>fault-tolerance</b>.

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

![Cryptor CI](https://github.com/marcospgsilva/cryptor/actions/workflows/ci.yml/badge.svg)
# Render

## Follow me

  * LinkedIn: https://www.linkedin.com/in/marcospgsilva/
