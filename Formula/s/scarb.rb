class Scarb < Formula
  desc "Cairo package manager"
  homepage "https:docs.swmansion.comscarb"
  url "https:github.comsoftware-mansionscarbarchiverefstagsv2.4.0.tar.gz"
  sha256 "d5dd740e51985303659e526b9e430e54d2299e9a925b0d505676149f57d53da4"
  license "MIT"
  head "https:github.comsoftware-mansionscarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dae51a5c86fd6202c575418b9d520d5de8e0800e0f33d999e7fa2b2af37e8194"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bc7fef1fc6926a522bcafcd3b7f49b3303d8ded7a59dddd58b881bead56f2d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9df95eec255bc25e7cc38810d0c52e8a4fe3ac57ab3191e80a3fd62301dd6f95"
    sha256 cellar: :any_skip_relocation, sonoma:         "35d6a41a97dec20e1a806627e16db1bd5a288ad108565a7a798cf1b604267c30"
    sha256 cellar: :any_skip_relocation, ventura:        "b71a19baec58c417f45e9232e47527ffcf53cf3c2af55d2631845842db9a85b3"
    sha256 cellar: :any_skip_relocation, monterey:       "cd084c14d7d9cc4d4bf309bfc79cc8031bf7a88cde8a6833bbd34c9278efa3c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f782da3cb0b66554a239f396f958190db56250f149698fce1e69e5b7cc160de"
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