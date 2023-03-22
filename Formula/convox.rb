class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghproxy.com/https://github.com/convox/convox/archive/3.11.0.tar.gz"
  sha256 "ef1e77ac0df0bba15fc53a6710fcdbbd11a922d3f18a75c6efbeaee79b776af6"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "464bc5fbd32af047e2f2f7ad747488b5864f7131dcd1f1123e6bad607a6da9e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82e66f93bc6cde9424c290aad987f115a2a314ffedebef582d87c9513ee1cc84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fba4273db7a7f3e398c07ea764d7d370257fde71838932d95f3c6c4aa3b860e0"
    sha256 cellar: :any_skip_relocation, ventura:        "02fc755b84ba324b3cdd6399cdd6bdf425889c9981e01402a9726e7706304405"
    sha256 cellar: :any_skip_relocation, monterey:       "efc8b9567e2d4be5cbed7f3124b6c16b3b05c097cfb0ac4a4c4c16de44782d14"
    sha256 cellar: :any_skip_relocation, big_sur:        "4143bc4f53581f39b86a223c2aaa87576b8f92aed9e301307493d5da93488774"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2411ab84dbe3c27dfe0f34fcbffc4d66ddf51b9ca07113e36c5bbeaac0f4908"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end