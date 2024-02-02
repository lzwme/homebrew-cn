class Scarb < Formula
  desc "Cairo package manager"
  homepage "https:docs.swmansion.comscarb"
  url "https:github.comsoftware-mansionscarbarchiverefstagsv2.5.2.tar.gz"
  sha256 "3869ca675ff250b20ab25396c7d0dcff3dc5011b5736ad802f4b7d3639b6026d"
  license "MIT"
  head "https:github.comsoftware-mansionscarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a47fefb76312f2ebaedf4b97c5aa06ebe5861edb72a5be62401d9aea9d8536f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2de1c0f80f48f72bcc7f77b571882dbe5e45ebfc42d6fb504dcb90b6cc6fdae0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56234dfe1945502d72ac634dfbeefb19c6678b3b5bc5fd51207cbccb85cb69a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a480d0bcab2cf6722144e78f7c279e024cc63b38a4cb03d74454541b5d631a4"
    sha256 cellar: :any_skip_relocation, ventura:        "efea07cccdcd67a9e181f683940abd80e022657583adf9d86abb2b8e2aee0893"
    sha256 cellar: :any_skip_relocation, monterey:       "75b392deb65ae997298e689ab0fafdab970efb5fe703f5edc9e2677e70ce623e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0229dca0884e9d59db4797b1e6b0716d866ca9100d00a6c9eaa52a370102f2a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "scarb")
  end

  test do
    assert_match "#{testpath}Scarb.toml", shell_output("#{bin}scarb manifest-path")

    system "#{bin}scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_predicate testpath"srclib.cairo", :exist?
    assert_match "brewtest", (testpath"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}scarb --version")
  end
end