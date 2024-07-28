class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https:github.comEmbarkStudioscargo-deny"
  url "https:github.comEmbarkStudioscargo-denyarchiverefstags0.15.1.tar.gz"
  sha256 "74be710087d7ecb5d53c14d68474e53918d6a147fd03e686bc8bd8821bc277d8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comEmbarkStudioscargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a509675baf8128be2bd5847eff1200925dd1ccaf5fe0b6a4d6f9da7b6f0369a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "646bba23cbfb7b4fcd27149bf614a35425329aa97caff94df79b7e89efc530be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76c7008320b625c4c1292661e96d7e44131d552c009b07f1b51cce80fa321c19"
    sha256 cellar: :any_skip_relocation, sonoma:         "9433a164fdcb93583cf398958eaaa6ddda004e5b7045fb37057ec96874b53221"
    sha256 cellar: :any_skip_relocation, ventura:        "71e84b8380f6a3ffd4f9acb76f40da19dd72e083c18d31d7434f68dfc66c772d"
    sha256 cellar: :any_skip_relocation, monterey:       "068e48851315358f169f3601d8c50abcc839834a86051b49f5ac5488b1e9857c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a736ac134739f505ee73fc3fd0eacc7ef705b7e2707d49f14094a542ef8656b"
  end

  depends_on "pkg-config" => :build
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
      EOS

      output = shell_output("cargo deny check 2>&1", 4)
      assert_match "advisories ok, bans ok, licenses FAILED, sources ok", output
    end
  end
end