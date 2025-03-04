class Bacon < Formula
  desc "Background rust code check"
  homepage "https:dystroy.orgbacon"
  url "https:github.comCanopbaconarchiverefstagsv3.11.0.tar.gz"
  sha256 "a27b37af7e38be0888003eb5da4ce01b803fa78758a1cc8c857a4689e774a0eb"
  license "AGPL-3.0-or-later"
  head "https:github.comCanopbacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee81b93e97acf5ea02071b4cfa68069b1ea68d8c92a65798b3c482b419bbe0d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a14dcc33c3db2ca4d868a54aaf4037a3c763486df589446e7cc8b7fed508d30"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb1ccb3e02811c9f41cc58f3cdf5a51c63e81d7a52d534c6318c22753053e8c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb40b66d09e45f7b23ac43011e5a24b688276904bf67bb6227679fa46e62c626"
    sha256 cellar: :any_skip_relocation, ventura:       "da89c20458ec19a36daf5af2167802ded4940045450eea67998edbe7768f487c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edbe377d3c31c3d781270fd03984ddaac33a5a7f86f170212076f20c4a92f4b4"
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