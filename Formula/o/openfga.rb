class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://ghfast.top/https://github.com/openfga/openfga/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "1cc28117a5d032dcd3e8ec629ee25e6dc1e293e0192626b10d550c30dc42e768"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70bcf74384a374d329c21e5d6aeeafb555c33195e8ff1c1ee26008bced7774bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "117a992551102e3ea3acb39921efd99aacfcacde984a33e5a2b3d7b2931dd7e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b022241d53450b7c62881ae58a6ff479437eba2ac0380f5015e397204cb132e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e325cb1667c33122a3c170a46376aafdf2f968f8b543993342941fcf384bc62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0e9b962f6c6e91ab175c68c2a60952aaffa2fd106366a4329adb15d1f8cb0dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb12c4a389e1102736c6a4f1a4878d8f8cc4195cd17eb324ba13276857d4307d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=#{tap.user}
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openfga"

    generate_completions_from_executable(bin/"openfga", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openfga version 2>&1")

    port = free_port
    pid = spawn bin/"openfga", "run", "--playground-port", port.to_s
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end