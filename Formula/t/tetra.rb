class Tetra < Formula
  desc "Tetragon CLI to observe, manage and troubleshoot Tetragon instances"
  homepage "https:github.comciliumtetragon"
  url "https:github.comciliumtetragonarchiverefstagsv1.1.1.tar.gz"
  sha256 "afea2353f43d47e16958fdff05fdda8ddbbb7afe7821b8657ae39c7904cdfa91"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ef9b5df7c359959a7d510fe9d420d63455d297dcff6f63e599cf856b8b7f53c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "877857312fe4caedc0ea7040c83d6927c46728460ffa9c42dc0fa058c8069e22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d6365dbb93e46c8a6a182b99b454e5872b8f519e342fb8ea8d00095e8b2ad7b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1818ba3b5ccbab8063c134dda5cdc9fc4dca103fb100ca3096eb074dbfb4d27"
    sha256 cellar: :any_skip_relocation, ventura:        "e5e8c36b008cddedf15e47f0f70fe8697af86ab7deb30d51e9a993b24fa567ed"
    sha256 cellar: :any_skip_relocation, monterey:       "aef0ff4d59c713cccbb55de571e29a88e92cb49372cd154437a0cc5e53a317d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c835dc72fbc5cf481d6c1ee255944497996aa2c8ad2e497e7842c451ff68a74b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comciliumtetragonpkgversion.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin"tetra"), ".cmdtetra"

    generate_completions_from_executable(bin"tetra", "completion")
  end

  test do
    assert_match "CLI version: #{version}", shell_output("#{bin}tetra version --build")
    assert_match "{}", pipe_output("#{bin}tetra getevents", "invalid_event")
  end
end