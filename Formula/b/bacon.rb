class Bacon < Formula
  desc "Background rust code check"
  homepage "https:dystroy.orgbacon"
  url "https:github.comCanopbaconarchiverefstagsv3.4.0.tar.gz"
  sha256 "4183b40a9c41a97aa59faa89f740dbee1580955d77963610fa44b1550ee9f323"
  license "AGPL-3.0-or-later"
  head "https:github.comCanopbacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b75c11b95edc1ae289c6028183ba2b90db4553613ce9376e5ca3ecf0abd2fbec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f49a70e4f7be7325e50f76f243cae31c64bf66f4ebf9f37b6494c0b963cf153b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3813019cb0fc4955e627ba3877fae465cd5405b648e922b7c49c585d9e9a57e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "141a9d6a8b505eea17d73f701d0fb9717cc9806a786d4890319036a536c4be92"
    sha256 cellar: :any_skip_relocation, ventura:       "98986d21d54ce64a15d98485d105095c86a0d3275b474a5a5b3822e914f26e1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63dfa0a80c3d2e220b1e9e53fd27f799baf3484174fde2e01cefb5a3a52bf081"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    crate = testpath"demo-crate"
    mkdir crate do
      (crate"srcmain.rs").write <<~RUST
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      RUST
      (crate"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"
        license = "MIT"
      TOML

      system bin"bacon", "--init"
      assert_match "[jobs.check]", (crate"bacon.toml").read
    end

    output = shell_output("#{bin}bacon --version")
    assert_match version.to_s, output
  end
end