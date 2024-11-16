class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https:github.comEmbarkStudioscargo-deny"
  url "https:github.comEmbarkStudioscargo-denyarchiverefstags0.16.2.tar.gz"
  sha256 "a0a21efb9bb42c3f3d62ac2d1378890a56b5744197e6acc7ccafb9a6bd4f8051"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comEmbarkStudioscargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e30b9186b6144ad067f9304e092d5fa4fbae11faff142a05ec50b0c8b7c6b54a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "956928d9a20fb1a0af8611d694ae4147318e6fa115d1e24d392e97f56299e8b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac17200f682b74fad773fe2204f09d2cfcf5ec4c045636ad90abeb1fef7e11af"
    sha256 cellar: :any_skip_relocation, sonoma:        "0650b56be8e21c54008e1fc156c15eb3f56f81a73d1c81c2cd31e5ff49ad53b2"
    sha256 cellar: :any_skip_relocation, ventura:       "11b85bf7953908126f10ec8d5f7a476ad0f8a4628d6e754b997b76b6f34b795c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ba5d8e5e155b50caa91ccbc8c2785bc94fb94d8a6115e1ef886c6bac48a3d29"
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
      TOML

      output = shell_output("cargo deny check 2>&1", 4)
      assert_match "advisories ok, bans ok, licenses FAILED, sources ok", output
    end
  end
end