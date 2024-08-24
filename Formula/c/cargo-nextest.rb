class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https:nexte.st"
  url "https:github.comnextest-rsnextestarchiverefstagscargo-nextest-0.9.75.tar.gz"
  sha256 "a8229044e8ba59d519c3aa5fe352c3b4fe8435ffc07fbad251246047bb1ab64f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b419e3437f9f5ececdf420914265dbec9076d56002b21773a0c7dc111384cc11"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb00daa17af64d29181dc26b05d3837cbca0c3d896287dfb222e6c5a45d799f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37131b1ffacc0854aeabab094a4ad4cc4f653b553888b0f5326079b307111bba"
    sha256 cellar: :any_skip_relocation, sonoma:         "46c2e789d4b5f4d6a6f0b416d19f50dbf6ecc3c1e99904b2f5dd6cfafb383faa"
    sha256 cellar: :any_skip_relocation, ventura:        "207eceb02a6f130b02f887773081bf62e4115d64770f01ee9d47afde937edb00"
    sha256 cellar: :any_skip_relocation, monterey:       "54715ea78ed6dcd7af187bda378a4945553d5fa10495c94ca1a2611f5e68cb47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4a978b99f2800ba262959904ab05acf0da984a4f882775737b53e82dd1a5264"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", "--no-default-features", "--features", "default-no-update",
                    *std_cargo_args(path: "cargo-nextest")
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

      output = shell_output("cargo nextest run 2>&1")
      assert_match "Starting 1 test across 1 binary", output
    end
  end
end