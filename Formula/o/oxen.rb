class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "55a15dcf38fa85c6d67ae63dcb8a2102b3eac36af7620ceeddd1479156bd94db"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  # The upstream repository contains tags that are not releases.
  # Limit the regex to only match version numbers.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8101725e0600ceea0b0a3261c7ef7245eba41959a52ec5ae49cf69f39993d746"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e35b943c335d1fc5bd6e0078ee8681b6597f511ffb351a5105694642b879d33f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b73e3eec719bbf8aa2f1a895fe731e73223bc27b42153ca6379a12d823f93ba3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d539af6cfb313173c656633edf3fa491c10083ce0da675b743a7e7ac554500c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33052ac4e199f77b0c1692e083f117001f02e2d50ee6fef347da48fc17f73bfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f59e607a256298bf7515b85152a96399a802509dc63f9549959538bc61815c6b"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "llvm" # for libclang

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end