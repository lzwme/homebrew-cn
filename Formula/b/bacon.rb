class Bacon < Formula
  desc "Background rust code check"
  homepage "https:dystroy.orgbacon"
  url "https:github.comCanopbaconarchiverefstagsv3.9.0.tar.gz"
  sha256 "64f65248e4be36347611315b3168b015324b137cb35207342dfdc9712051bd83"
  license "AGPL-3.0-or-later"
  head "https:github.comCanopbacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2788faccb99d04ab5b8e7a69589c376456fb668c24d468c2a4e428ccfa82698"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "602db850cbcffe619afeeeec30a9a8b3ea57ed9fef82a408cf6ba17f273e8708"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4bc6dd3389a3fe67e276df9f75b8da9a35c4e4f357513dd7e3316413fe23c110"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8bd2119fe7dc22fbae451914946b81e6cee9e95aa01c84b5cf1da2b48ba300b"
    sha256 cellar: :any_skip_relocation, ventura:       "0048c2f949fe99a3aabc40de4228d7e3f1c4f555547a728a6720c9ecc1b313bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1721e9d8e2d3a402b1c7826c041ce8e2eb6c10ba6748dea96183e8c25f23912d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  on_linux do
    depends_on "alsa-lib"
  end

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