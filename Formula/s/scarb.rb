class Scarb < Formula
  desc "Cairo package manager"
  homepage "https:docs.swmansion.comscarb"
  url "https:github.comsoftware-mansionscarbarchiverefstagsv2.5.3.tar.gz"
  sha256 "53944c95c6bc14fe3694c80e4834f2796394858f528b378329b8045a4917b917"
  license "MIT"
  head "https:github.comsoftware-mansionscarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8d49593148cabbdf9d991bf9ce3b4ca0b8c1c80f95032263a1de7fe1a9b5b4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f01ad8b60f736ed97885d0ba25c5f997abbfea6a0d8f0d201db9057465333740"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fc773ed82038ff33a0c2f1bc0a3e4faadeaa76e853b594f21e3160d6f253625"
    sha256 cellar: :any_skip_relocation, sonoma:         "0aa886f7148a4128cd1a5d604dac30e1a766aaea5fadda686d95f4f377722363"
    sha256 cellar: :any_skip_relocation, ventura:        "78cbc5dd61f6c3b92fcb7020a93c571a9b2f2e73386c00f86c9cd4c5a9ef37da"
    sha256 cellar: :any_skip_relocation, monterey:       "a7c5a72fc175f7e43f43f2c4f6859de430d2d3fa9bf874f370ebcfc1ba3b7c4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc0fb833e13b2484fa35e4ca8f6e621aa1a1973e5e809ba6cd011de9b9666929"
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