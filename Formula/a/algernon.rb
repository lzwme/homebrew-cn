class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP2 and template support"
  homepage "https:github.comxyprotoalgernon"
  url "https:github.comxyprotoalgernonarchiverefstagsv1.17.0.tar.gz"
  sha256 "520ded9f63e901401c86b35ae52abc2fd114f1162884114df9aac060e73f7789"
  license "BSD-3-Clause"
  version_scheme 1
  head "https:github.comxyprotoalgernon.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "929372a8f6a568160754138c664ce1549aaade6529952ccac391ff44ce81e5aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e51e2aa94727cbe839fc47d364f8aa3e2dbc4d990af3cef88f09a1519846941"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a54fb61f93b7dd77be237e694d232fe046248bf0772402ff5fd78132015cb367"
    sha256 cellar: :any_skip_relocation, sonoma:         "e90d1facbc2ef70d0f760a112ad98840490bff0641fd78a617880f22acd0b194"
    sha256 cellar: :any_skip_relocation, ventura:        "e4749cae2f5fdbc06ba0e32adf8c68f0440547f4c91e19c2305650b133772759"
    sha256 cellar: :any_skip_relocation, monterey:       "903aa1dbbd997f2fcdd93c2b625ff7403e8e4e54eb08088ea1c3b2c8a2aa863d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e25c9627c2f9c25afe3ca8bd623312f785b2ff11a78de4bf0edf051c62fa3296"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-mod=vendor"

    bin.install "desktopmdview"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}algernon", "-s", "-q", "--httponly", "--boltdb", "tmp.db",
                              "--addr", ":#{port}"
    end
    sleep 20
    output = shell_output("curl -sIm3 -o- http:localhost:#{port}")
    assert_match(200 OK.*Server: Algernonm, output)
  ensure
    Process.kill("HUP", pid)
  end
end