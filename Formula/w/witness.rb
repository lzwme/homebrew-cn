class Witness < Formula
  desc "Automates, normalizes, and verifies software artifact provenance"
  homepage "https://witness.dev"
  url "https://ghfast.top/https://github.com/in-toto/witness/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "5c4702a0b15380f82c1e421c15582671321c5c0a406093129bcfe288c68693dc"
  license "Apache-2.0"
  head "https://github.com/in-toto/witness.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c1bef2206373f8cf41b00a3e0c8f2ffb202e84e261e2cd44708180f7a4f0ece"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfdd650772a339c3779acbc2b8095e1caec3901901f0f91a6b926615839084ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "816dee5bb5177c2767fce2d1a2061a9bafc78b4cd9b9cd1f727e06476ba41cf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "73c84f98d57ed1d2c4464d9b732a13632a7f3ba601c3e55ed7090ab8398dc258"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c16397751c0ae4e65a36f62db89fab7985e6abb739440769c2e4ea7f1d09156d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fad8bfb1d0b7dd40b66def36ebd2ed35b35b07055479f6942f8b7833d2a4d54"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/in-toto/witness/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"witness", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/witness version")

    system "openssl", "genrsa", "-out", "buildkey.pem", "2048"
    system "openssl", "rsa", "-in", "buildkey.pem", "-outform", "PEM", "-pubout", "-out", "buildpublic.pem"
    system bin/"witness", "run", "-s", "build", "-a", "environment", "-k", "buildkey.pem", "-o",
           "build-attestation.json"

    output = Base64.decode64(JSON.parse((testpath/"build-attestation.json").read)["payload"])
    assert_match "\"type\":\"https://witness.dev/attestations/product/v0.1\",", output
  end
end