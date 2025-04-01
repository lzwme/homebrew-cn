class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.34.0.tar.gz"
  sha256 "9206dfb2299d2f49b898bd48fe5444529a5afc14ec19ebea7d2ebf766fa687dc"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab0a0777e2dc10a2b611a79f483e660f05a13b3bc6beda94d2e414b620818b8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70343d0a54eb413d2042936ccec1e790e6bc7c208d6bdbe4ce4ef5842ebafe89"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f160dfba7a6c92c51f6779789e8c09609dfd98da0d7d8d9c1ed3e3ad4a7e7a48"
    sha256 cellar: :any_skip_relocation, sonoma:        "acd4c41a584a69b53d8d676b4b3860ad289ce034602becf6f840389d117f0748"
    sha256 cellar: :any_skip_relocation, ventura:       "3940b49fea157ff9addbfa9e500884d575e5482d606d97cd706256dcaef70ef0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37eb2167e9cfb14a5f7a686b8c3fdc64cf621ab2629f0763046ead3f55199a9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a6dfa8e8b5f5c600cb485d4cf5947b83dfe890d568b4d561d7002b9bba68d6e"
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