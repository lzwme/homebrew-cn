class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https:rye-up.com"
  url "https:github.comastral-shryearchiverefstags0.42.0.tar.gz"
  sha256 "71b61b8ef6b2aa1c9633b18e72d2f2b06fd3f47264cf276bc7f65e4ec0b1c7af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a2a41e057e4b94d62ac68b66a166db48b27cf62ea26dbbe8e3eb6b9e0d56121"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ccbeec24953d010cb0871a4a38d3edd59459fc67ce8564ea16946af84e154f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6d2e9e9101a5e7c2012fab9839e89e2a13fe5cfebdcc163fd2209dd398911c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b80c7bfd8057edd00512624295a85981998c3fca20dc979dfff9c0ac37c3ff69"
    sha256 cellar: :any_skip_relocation, ventura:       "c38f22278fdb7573997f955a56f5d507f9d6d6b4e9959946bfbfa671346d3c08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9c176fb98283e386f377e1fa2e2a39bd0597572daecbd27098f2ff387aa9fc1"
  end

  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "rye")
    generate_completions_from_executable(bin"rye", "self", "completion", "-s")
  end

  test do
    (testpath"pyproject.toml").write <<~TOML
      [project]
      name = "testproj"
      requires-python = ">=3.9"
      version = "1.0"
      license = {text = "MIT"}

    TOML
    system bin"rye", "add", "requests==2.24.0"
    system bin"rye", "sync"
    assert_match "requests==2.24.0", (testpath"pyproject.toml").read
    output = shell_output("#{bin}rye run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.24.0", output.strip
  end
end