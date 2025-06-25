class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.38.0.tar.gz"
  sha256 "8ad0749135751e4cfc286e86115b878ecffe21674d3faea3ee6f052ba52e0712"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdb79bc6629237e677a79f8a0c6015bc09123d5199a95b4330c8dbefd2219393"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc3003a78a90c6b04561d169385e5c78c3618ad25ec5273716c82a675d1104f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c441daae01d424aaada3c6d3f38881cf2201644ff36d4bc0684a0bb8662ace5"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee943c2912e67ef4e21b6255385406e08d9a991ee168d44343d8e084f6fd92e6"
    sha256 cellar: :any_skip_relocation, ventura:       "1e3b47b07201edd36b1779bb8e0622d911462634397ee19fd937a8ce4d0e9bff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03d0c12b41fa757c80e3ba08d314f3f0a14c08191528b3b1fbfcfa562aa4ece0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0132c9392eb79282f767e27c68cbfe39478c60cade87e4d937885a94e7bac715"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")
    generate_completions_from_executable(bin"moon", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      (libexec"bin").install f
      (binbasename).write_env_script libexec"bin"basename, MOON_INSTALL_DIR: opt_prefix"bin"
    end
  end

  test do
    system bin"moon", "init", "--minimal", "--yes"
    assert_path_exists testpath".moonworkspace.yml"
  end
end