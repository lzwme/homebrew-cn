class Bacon < Formula
  desc "Background rust code check"
  homepage "https:dystroy.orgbacon"
  url "https:github.comCanopbaconarchiverefstagsv2.18.0.tar.gz"
  sha256 "ea7c5f600f2a8be3e38bb1fec17d5e8359e1a6abec7c05f57aee570441152636"
  license "AGPL-3.0-or-later"
  head "https:github.comCanopbacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da97af5b46bb926a2bd1f83585e67ee821112bcdecf92f9dc4a4bd09b80d193e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "deab40156f3c424e255d882e0364c696a51e83f2c589333b628220df65025a39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42a066c99daa4e463e1ec38aee868785345cc6b6deac6f8b59b96032b0d05fbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "99576abc135c4215c1ff9203495c6045d1bc3ca4ba2832829a62fd50d3fd8e18"
    sha256 cellar: :any_skip_relocation, ventura:        "d369ecab48e2c9a2437ba0d7bfbac95e1873b80ad5a0e9a51aff909b77c61471"
    sha256 cellar: :any_skip_relocation, monterey:       "63cbbfec5402726aa39535be7899ccc387b49acb9934031da323d1ed7b391a41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "984e344ac46e56319b95688d29da50ad50a85e9818a3515acfa74ffb5652b316"
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