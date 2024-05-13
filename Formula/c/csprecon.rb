class Csprecon < Formula
  desc "Discover new target domains using Content Security Policy"
  homepage "https:github.comedoardotttcsprecon"
  url "https:github.comedoardotttcspreconarchiverefstagsv0.2.0.tar.gz"
  sha256 "846e83e6fad65ed31134600aa908a9d9d3db55c6c963eae161887fe62b362bca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "484f40210147d9b0ab0d299b97e08a238da09f5dc4df5b53d6a0d8e3854eb877"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6606b4fce15e31a8b1b7f38a8e74ea818b506953921e81b96f7d2c3f21d510f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "402bb4a3576d51aec74b9e15ffc577aecbb49e5c1f070ab86f5d1705bf060648"
    sha256 cellar: :any_skip_relocation, sonoma:         "912783c446078f2bcd1011b8456ca8a3dae10dc4b2ea8aedf056d32c8b1a24a6"
    sha256 cellar: :any_skip_relocation, ventura:        "144a757ec2dda95bbc217dc60828e0a7d15a1c175c9e13d70d23de63a4043d7e"
    sha256 cellar: :any_skip_relocation, monterey:       "f39b4cb1d96830acf124faf64f3581b4977ec155865cb044b36a59a52d071586"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "165bae4cd647dc3bd004f57902c050709edfd1063d275d3ce7d934f623edfb89"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdcsprecon"
  end

  test do
    output = shell_output("#{bin}csprecon -u https:brew.sh")
    assert_match "avatars.githubusercontent.com", output
  end
end