class Bacon < Formula
  desc "Background rust code check"
  homepage "https:dystroy.orgbacon"
  url "https:github.comCanopbaconarchiverefstagsv3.14.0.tar.gz"
  sha256 "dd76666adfd41de63d8c53dc667b3e4d64962b473ff0eb2cfc3052a09c6f3af9"
  license "AGPL-3.0-or-later"
  head "https:github.comCanopbacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d528a9e0a0fec4821136ae87a2555bf7ca40b420b39b513957ae2f281f22913"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f30fee470321fb47263c2e74406a2faaad66cf952017da7f2f3444b3f7282da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54ed4d8e8e88a89e12e44fe1f6d9c4c5e387b99aa926ee9f6319c172221ac9d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a441c65bc51110c175f0e3104c0617c3ca8f802aad9870be5f3ad6fc16ab65bf"
    sha256 cellar: :any_skip_relocation, ventura:       "fee2e18357d5a9cd4944c0fa5407214a8d3ca165ba53d2095fc6c2b8647abb53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4822c3a8aeb8c1bf7e606c8f700506cd1aa836708f96c0c6ba95643b67ce25b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab18eb2f95e2ea00daa921cc1f5431da39c29ccc96c19316e6fe19243b4c3a69"
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
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

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