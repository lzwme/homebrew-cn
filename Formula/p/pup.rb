class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.15.1/pup_1.15.1_source.tar.gz"
  sha256 "97db576a131862f2492ca04535b8fe59f0130bb72bc80d3fadb8a88e59eb69cf"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0726a84c9dab9d0c7d7b8f0bd2ec838d601a9f2be26a7aba9ba7851268d8a82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bd63da11bea26f30414cac71c5b80207fc80fd7c3d4a462c29360e1db044bdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d072d3494479a46811ce95fac1ff0d682d61fb0e8950df3b2a2b2c6788e336da"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d907096c1d7f1045380aa481acd16af8e74cfecae7a21b4596bad9a4b68334c"
    sha256 cellar: :any,                 arm64_linux:   "819d75713219eed03f6adf63ff5992f0f7010330337bf8896bd8586dff923de0"
    sha256 cellar: :any,                 x86_64_linux:  "3d3e2acf029b1050ad428dfe86c7cba15e6c3ae9053927cb863cb10b3f7df69c"
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