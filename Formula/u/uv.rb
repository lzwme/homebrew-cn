class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https:github.comastral-shuv"
  url "https:github.comastral-shuvarchiverefstags0.4.3.tar.gz"
  sha256 "f2d207e638d85723e53028301f57dee6ea48fdfa5754c86733bb832c2942db1b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comastral-shuv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e21f582d0206a4c1ad6987e6b7c0e3a8c259914bd6b4d783bc92bad3e5e73d5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6a35f399270e87c60d8c9366ba3869a6669fda122966ac3c4eecc6b494373fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13a1b97fecb23921709089e92fb82e2e1160cf7999980a3ef487521a4fe37e49"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d0ab6298f3c9e968a2b9618b744505b20ec75d48c7f0af505f5c9d75b65ad12"
    sha256 cellar: :any_skip_relocation, ventura:        "b055cd4e6a1446230f399e6913ed3aebcf6d54aea80a8b472b67f452fc178cf6"
    sha256 cellar: :any_skip_relocation, monterey:       "6330376590c8a7c976e08354dcf2fb37405593af3f1e82a49696f8eecb2f4e32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8b9a57bbb315021b79498127426a6ddab0cfdb1a5bbef0a3123a64954c96e3c"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :test
  uses_from_macos "xz"

  on_linux do
    # On macOS, bzip2-sys will use the bundled lib as it cannot find the system or brew lib.
    # We only ship bzip2.pc on Linux which bzip2-sys needs to find library.
    depends_on "bzip2"
  end

  def install
    ENV["UV_COMMIT_HASH"] = ENV["UV_COMMIT_SHORT_HASH"] = tap.user
    ENV["UV_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cratesuv")
    generate_completions_from_executable(bin"uv", "generate-shell-completion")
  end

  test do
    (testpath"requirements.in").write <<~EOS
      requests
    EOS

    compiled = shell_output("#{bin}uv pip compile -q requirements.in")
    assert_match "This file was autogenerated by uv", compiled
    assert_match "# via requests", compiled

    assert_match "ruff 0.5.1", shell_output("#{bin}uvx -q ruff@0.5.1 --version")
  end
end