class Bacon < Formula
  desc "Background rust code check"
  homepage "https:dystroy.orgbacon"
  url "https:github.comCanopbaconarchiverefstagsv2.18.1.tar.gz"
  sha256 "ba2e6dfeda00569d31ac2ed05b2215285a64a365fad0a039c5a664d3e63209a8"
  license "AGPL-3.0-or-later"
  head "https:github.comCanopbacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "122cd25f22779d32ca1416acd8bafb897fe0d0440d35ef8b47107d72b6b95dc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6825fb86afde6f80b6ee5f812d2472ca8f35a9502095a189566750e52a920552"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5dfb8a0e1145c19af5921445942ede3c915b1aa53967a63c2b0c9a8f321206da"
    sha256 cellar: :any_skip_relocation, sonoma:         "b22ccfa50cfee52469be909b15416ab82dee28d606b118d89ed91308219475cc"
    sha256 cellar: :any_skip_relocation, ventura:        "3e14421d38ba2c1fc0bc3a45fbfde4dba1c2b9528f789623f70b9b29a089ae98"
    sha256 cellar: :any_skip_relocation, monterey:       "dd4b31820f4e36ce1b9519fbf91fb159b19948d4d0b0574685f4951a8dd8b68f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74bb1d19165d02a55d287584bf9c495c57fa6c1e9641b9ab0eca990dc97c660d"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE"cargo_cachebin"

    crate = testpath"demo-crate"
    mkdir crate do
      (crate"srcmain.rs").write <<~EOS
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      EOS
      (crate"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
        license = "MIT"
      EOS

      system bin"bacon", "--init"
      assert_match "[jobs.check]", (crate"bacon.toml").read
    end

    output = shell_output("#{bin}bacon --version")
    assert_match version.to_s, output
  end
end