class Openfga < Formula
  desc "High performance and flexible authorizationpermission engine"
  homepage "https:openfga.dev"
  url "https:github.comopenfgaopenfgaarchiverefstagsv1.5.5.tar.gz"
  sha256 "5096e304d72ea879a4dcc6a92f676173d9ecf0412da84bb9ae5e76bc133bc39f"
  license "Apache-2.0"
  head "https:github.comopenfgaopenfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0793a5919e976db8217929539e4eb0208f7ad7752f46b35bd25c5f6cdc2aa6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81d9e3282eba38ef053abb1e3bf9a60b457de0df25fd20b89d49082a43b30b93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a52eaa1ebf5a5d31fd7acad706eb515dee5e4dd7a7f8a322cb9ec20778627ea2"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb59164308416415982f34950d43d165f69f54f206c2ff6dcb70aae30a4e664d"
    sha256 cellar: :any_skip_relocation, ventura:        "3c6cc0d73b0d63e5f8eb654512acb0c9360034fed89913f7c7fe897e08b3e998"
    sha256 cellar: :any_skip_relocation, monterey:       "e5ef90248a6751b58aba1210635003d27ff7ed285d4d451574db562d4170bc84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cccb25925088ca1c7505742f3ccf6046af0f7a636e17ea1b377575be429f386"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comopenfgaopenfgainternalbuild.Version=#{version}
      -X github.comopenfgaopenfgainternalbuild.Commit=brew
      -X github.comopenfgaopenfgainternalbuild.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdopenfga"

    generate_completions_from_executable(bin"openfga", "completion")
  end

  test do
    port = free_port
    pid = fork do
      exec bin"openfga", "run", "--playground-port", port.to_s
    end
    sleep 3
    output = shell_output("curl -s http:localhost:#{port}playground")
    assert_match "title=\"Embedded Playground\"", output

    assert_match version.to_s, shell_output(bin"openfga version 2>&1")
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end