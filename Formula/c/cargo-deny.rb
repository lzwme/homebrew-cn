class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https:github.comEmbarkStudioscargo-deny"
  url "https:github.comEmbarkStudioscargo-denyarchiverefstags0.14.14.tar.gz"
  sha256 "736d4a258fe6b0d4b1096433953f2e38cb760936c3595a11674bec46884db83a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comEmbarkStudioscargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a66d4c7adde17b7e5233664d7773ac9491d514e26d642a2a889f113ca21c5e26"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a6b0d140d8aef83ddb763a5051ae6a6ff191bcaa2b01f6c5173fdab941d582f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37dd8a992d7b1be5fbec2a21205e50f7b8a72dda8850b90608fd899b36714fb0"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d10b54230d482f2bd267803a7f4e611292dd4336722775d5bbc01800d581817"
    sha256 cellar: :any_skip_relocation, ventura:        "5f0ab364e1383f7885a6ca02c2a0e6bdcbe0e7c7f543ef4e64df5135406d1ab6"
    sha256 cellar: :any_skip_relocation, monterey:       "714fb1e6a38abe80f843e5267e7ea9336a9ad1786109ebab7bb24009c7839560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c985783e13736deacbb7f92dfd37fb43fd6efda47ec898b4e1fc64aa56e41688"
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