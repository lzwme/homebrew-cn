class Bacon < Formula
  desc "Background rust code check"
  homepage "https:dystroy.orgbacon"
  url "https:github.comCanopbaconarchiverefstagsv2.21.0.tar.gz"
  sha256 "ff43a713b5a301a90ac4e1432cc119f9e52b2563d71dbafa30546cef4a7aeacd"
  license "AGPL-3.0-or-later"
  head "https:github.comCanopbacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3636239d00a35382e9d22eb430869977473e4ab77716179c4528b17223fe3be1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "660031e5d4782925f864e6bd2fbce472385df3f7b176e27ece235f15dc9276bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0eda2017f0afa61d6f3933404e58a1a09bceea05035118686ddd4dc9824944d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "72930e1bc3ef203173cbb757cecae326c16c36ea015ad0b716ca55c35e045c50"
    sha256 cellar: :any_skip_relocation, ventura:       "a02edd06043e43d978668b0145d31b529055c8fa757204f90e8f68260908bd00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "002fdff64beace101a603456a2988c02281871cfe4542a6ac740c183158f70a7"
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