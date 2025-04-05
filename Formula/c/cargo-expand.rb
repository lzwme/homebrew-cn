class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https:github.comdtolnaycargo-expand"
  url "https:github.comdtolnaycargo-expandarchiverefstags1.0.105.tar.gz"
  sha256 "bf30b007ebc0f55f99db305d9d2936d5629aa809d2c9cffd79834f01fe5a8aa6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comdtolnaycargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24e22eefbdd9b614159dfb7402b8896e33e427099eabeff47e4a54796211b4f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67538cb91bc42b9d5b1d9de2b5046caec59228be421158e1adaf56af905f0aa6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71a080b8fca21e455e7fa21a5deb6aa5b2aec708c36b63c81352bc71d41bdc87"
    sha256 cellar: :any_skip_relocation, sonoma:        "78e0523c6abbd634dd4ff68d3686eadccaa45b523443942d99ee572664fa1c17"
    sha256 cellar: :any_skip_relocation, ventura:       "b85059b602b81ed322f9e9013e942a89aa778906ad837bbbe845ffba3675f89c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e5f9c57d0cfdeb3b377435c3d343eaa6208259d73825ec27b05ff3102993bbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fa362ae8e5a46b55d19a4c82aa892375109593cbe78760835fbe0f09a91bfbc"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "stable"
    system "rustup", "set", "profile", "minimal"

    system "cargo", "new", "hello_world", "--lib"
    cd "hello_world" do
      output = shell_output("cargo expand 2>&1")
      assert_match "use std::prelude", output
    end
  end
end