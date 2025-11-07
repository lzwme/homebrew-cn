class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.45.tar.gz"
  sha256 "464bbfb1b93c4e69d468e9f8f6d1cd95959b681565835b77d02c654c06080729"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "814b53bde648bc3b9cc33f6d5ae40aefbfc9b56182244d652f240f659f9ef27c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c6fd74114053dcbdc816b84f918c7229ed6b9b3d893ec3bb76ea3a278cd1723"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee8f685f4158832ccf57732705cce8af1c9677fdc3f5944c7d2f4f5ca4072620"
    sha256 cellar: :any_skip_relocation, sonoma:        "09167948d0c509834efa487edaa0bbe334c6a1e3c3073073e10a9f503bd76934"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8840a420ed6f0aa7c79668dd445fd2e194e2258b6a8bdc55ea67c8a5847f6074"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acf999a550199729a417c15db467259142fac65d1b327f75e4eb094541479e2b"
  end

  depends_on "go" => :build

  def install
    # https://github.com/goretk/redress/blob/develop/Makefile#L11-L14
    gore_version = File.read(buildpath/"go.mod").scan(%r{goretk/gore v(\S+)}).flatten.first

    ldflags = %W[
      -s -w
      -X main.redressVersion=#{version}
      -X main.goreVersion=#{gore_version}
      -X main.compilerVersion=#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"redress", "completion")
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}/redress version")

    test_bin_path = bin/"redress"
    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match "Build ID", output
  end
end