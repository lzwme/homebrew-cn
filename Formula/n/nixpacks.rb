class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://ghproxy.com/https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "a4a50db2c0cd814b9079b003b0205bad53c2470e2e14c55567749280852aaf3d"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42611555f074bd2ee22e7813e11ac1b662742105e0193d2503a60a8b1c919922"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d0b6ad86e959ef233dc171ed39e1a6ed89c5d158f01222944f84594b7410335"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "777f59950a44069227d56bfefbe2ef2f5b1b953aca277ee04ca82fd79af2df74"
    sha256 cellar: :any_skip_relocation, ventura:        "b52081f7fdcc32cbd7b99d98fb449b53254ceb599639b1cd905b5619b8f4056b"
    sha256 cellar: :any_skip_relocation, monterey:       "eaed4ae599b0c3f16c5b6bc5aa7832653bbe92b032c2879c3864d42fd6f72f95"
    sha256 cellar: :any_skip_relocation, big_sur:        "d43aaddca9c032315088239d21e4757ef1c49f33fa9be693f9510aa36c2ed556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "675fc4f795fc7b1d9286c3e06527b9b10e23ef8f8b184ba01b00afafc99fcc69"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/nixpacks build #{testpath} --name test", 1)
    assert_match "Nixpacks was unable to generate a build plan for this app", output

    assert_equal "nixpacks #{version}", shell_output("#{bin}/nixpacks -V").chomp
  end
end