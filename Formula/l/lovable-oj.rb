class LovableOj < Formula
  desc "Experimental next generation frontend tooling"
  homepage "https://github.com/lovablelabs/oj"
  url "https://ghfast.top/https://github.com/lovablelabs/oj/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "9b2cb6d53da1f9ae1a3565f2b773e2bcc87df9c400924ed81b19ccef884593ea"
  license "MIT"
  head "https://github.com/lovablelabs/oj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dce714cece0aaa232b014990a5b10e73c382642461231915f274878a20dc63a4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7373b74f9351f89f5d0aaabdb093db45f7e50654d0692aa29fa1562572b5efd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1615537239dd5ab7eb36573edbb2a17eb3acacd31422ca63c7f15d3299dad01f"
    sha256 cellar: :any,                 arm64_linux:       "f49f0f3e821aa25323438b20c14360b0f8e2dbfb7585007ce34e11cdcf3779e2"
    sha256 cellar: :any,                 x86_64_linux:      "3e6db2090e8ab8712b4a965b145e926a71da7379677cae4000610d3755edfa96"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # `v8` crate downloads binaries at build-time
  allow_network_access! :build

  def install
    # Work around SIGKILL on arm64 linux runner from fat LTO
    github_arm64_linux = OS.linux? && Hardware::CPU.arm? &&
                         ENV["HOMEBREW_GITHUB_ACTIONS"].present? &&
                         ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
    ENV["CARGO_PROFILE_RELEASE_LTO"] = "thin" if github_arm64_linux
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm") if OS.linux?

    system "cargo", "install", *std_cargo_args(path: "crates/oj")
  end

  test do
    (testpath/"index.html").write <<~HTML
      <!doctype html>
      <div id="app"></div>
      <script type="module" src="/src/main.js"></script>
    HTML
    (testpath/"src/main.js").write <<~JS
      document.getElementById("app").textContent = "hello " + "oj";
    JS

    assert_match version.to_s, shell_output("#{bin}/oj --version")
    system bin/"oj", "build"
    assert_match "hello oj", (testpath/"dist/assets").glob("*.js").map(&:read).join
  end
end