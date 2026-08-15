class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.10.8/pup_1.10.8_source.tar.gz"
  sha256 "75e323f486b30e258e158fbd0a3342fd28fc34fd7c4f5c85557794cf3f5ba754"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10df8718cddb0f97aa62a99a34641b42c4829e3f50b6a88b0b41267b7ae4a5e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afe1a6f5f66ebed8cf3b4c7cac25ae0e0d782f69ee6cc39de8038792fdafd7e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21fba9b2d5d87e483040eab6f5c9b702de3e2f0d2933c30da89260ecf9676493"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3db5d8b94e8e9f12c5cff46cd7e8ccdf362b04fbbb5ea2d8f4ffb62ace7cea7"
    sha256 cellar: :any,                 arm64_linux:   "5b05810b92bd9fb8691ca5d5e2803698caef70be9682d9ee3d4f29ad1a132aa9"
    sha256 cellar: :any,                 x86_64_linux:  "38ff1dcd33bb067c5299cef3665fa82e948a173b212e8ef3360de6d6cd270f31"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end