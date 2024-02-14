class Bacon < Formula
  desc "Background rust code check"
  homepage "https:dystroy.orgbacon"
  url "https:github.comCanopbaconarchiverefstagsv2.14.2.tar.gz"
  sha256 "bc3adc247cb410223b0db479597ed628641bb0a1a9e65ad46ef8a7e8fa7a053e"
  license "AGPL-3.0-or-later"
  head "https:github.comCanopbacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "457538dea3c00c3c360df39832d71670f593567ae5baa0117f3d0ec34c7f4c72"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c94b5dfc674c871594572738ed3d759060a414143d098b48d62e13647fab116c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "104ff87cffb3aa51c3ce81ac42dcf2d744af15a6fa8d071d25ea4b3b6eadd1ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c5abd757003b3c02e76d163ac5197cdff925239fe5880d6c802ae15aec06d4c"
    sha256 cellar: :any_skip_relocation, ventura:        "cf7a9336a63c7a793ec3ae7fcd532313664f42ea737d3c134d8b82814e01836a"
    sha256 cellar: :any_skip_relocation, monterey:       "768588473c35758c99dd9fe2c3b5d63bc8ade727851363232fa1f9325f43be81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "025dbed7030c35278a52e46d757f23860fc0e5a576174a80c6d170a1f31fdb17"
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