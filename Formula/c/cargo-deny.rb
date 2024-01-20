class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https:github.comEmbarkStudioscargo-deny"
  url "https:github.comEmbarkStudioscargo-denyarchiverefstags0.14.4.tar.gz"
  sha256 "4bdccefd935e6284c77365ab0704664426317646ffb0f343ae5c25fda8eb5677"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comEmbarkStudioscargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "168eff8eab3a2ce4236b3f06a592b379ef6cf2f502ceeddc2bca18d1c59d8a7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14a3d65bf1f6f4a02f7c71c46dfbf31f267525abb89561c189845b3cdbe86ca2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a226678e58986d98262fc6dce14d9b8c422fa21f2454e77084467781631b726"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b03113f35e061dac5dc3bdda843268601a2e20a61ec5847c65b5a416e5d216c"
    sha256 cellar: :any_skip_relocation, ventura:        "e70dca29d9cb1a064b2859129b1d6952092e0aad845473a30419b04254c79b85"
    sha256 cellar: :any_skip_relocation, monterey:       "d082ac87b10abd90ef49a59a135a937082d8669735b636f45316272739876185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e61bcadf63997b1c0d31d5389a119c8c92f0601d190c9545240f5d4b2b71e772"
  end

  depends_on "pkg-config" => :build
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
      EOS

      output = shell_output("cargo deny check 2>&1", 4)
      assert_match "advisories ok, bans ok, licenses FAILED, sources ok", output
    end
  end
end