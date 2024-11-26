class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https:docs.doppler.comdocs"
  url "https:github.comDopplerHQcliarchiverefstags3.70.0.tar.gz"
  sha256 "2cb5d460fb4092896a6e982ede6548bdaa7a79d3bdb0149b734854d3847bb405"
  license "Apache-2.0"
  head "https:github.comDopplerHQcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9e31a5ad2a9eb45390bd072877afc7843dd2ebfef7aae8f6741640f69897b9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9e31a5ad2a9eb45390bd072877afc7843dd2ebfef7aae8f6741640f69897b9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f9e31a5ad2a9eb45390bd072877afc7843dd2ebfef7aae8f6741640f69897b9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffda3e5fc936469ace80a1a4c286c85b7f29a317c5775e15b88339240ade39f0"
    sha256 cellar: :any_skip_relocation, ventura:       "ffda3e5fc936469ace80a1a4c286c85b7f29a317c5775e15b88339240ade39f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85481380965b9dd2851938f0cf66cb4b1098e1082843bf5059233d5c5fb1004a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comDopplerHQclipkgversion.ProgramVersion=dev-#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"doppler", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}doppler --version")

    output = shell_output("#{bin}doppler setup 2>&1", 1)
    assert_match "Doppler Error: you must provide a token", output
  end
end