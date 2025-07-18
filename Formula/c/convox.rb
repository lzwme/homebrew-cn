class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghfast.top/https://github.com/convox/convox/archive/refs/tags/3.21.5.tar.gz"
  sha256 "ffb6806b88095f7c76a4f4fb84f9297f8c2e8e07d75a4dafead7ddcfc7470e95"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "349e67c75c42c1ca333cd23e1a01f44231311dd7185be3e647d72fef660b863e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f847cf8d920c2ff815e77a0c6b20fd70b8f239a95b8d337e92c88ddac6edf011"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4fb21dbf47f456f66607dd069e18bc14d1aa7d2760ae89b01d60e4e4ecf31dc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa06a991bd71eb0f6bde3b322780e655d2cc0b70ba38c10d2063d645e367f637"
    sha256 cellar: :any_skip_relocation, ventura:       "72b4303e9f398bf6ad3262f121d0b877557c8802ff0b82c8ace3cb9714f5a0b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "100ed07e71c5f9b2c7fabce9779d5332aa4a20821427de11dd2a7912174c53c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4947b625b9ddac31e70246c0e40c6f3f5398a8faa85bea41814f8cd48b54ca98"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end