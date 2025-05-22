class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.36.1.tar.gz"
  sha256 "0531e04adfc7a386a503d52047eb9aeeb8c1858eef425c36ff7ef02d31aec67d"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6487519f1b2c703d5ea8514986842e28109cd2f06009e8e8c892ef9b3f64a64b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "478b5d5ad865344b6a78453707158cf48ac300548bbc9749eb5aa65e281af65e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f717d872f7916a146fe5c70b58e8c6b8dcd2077d392d3e757da4575529481752"
    sha256 cellar: :any_skip_relocation, sonoma:        "613e6196b83a477c6d8c30082717bc36ca45e219203dc6c3b44192af928bc2f9"
    sha256 cellar: :any_skip_relocation, ventura:       "426a64e5a53632ec9a3c8c8fd478afda0d4fddb4128cd7860bc1a9f9c49950c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bfff59d68e37e3b75697c54a552e7f96da86871a0c44604ae959f2a5ebf38b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8ad23dba879eb83751a4a053b50f882777747f110b96c6ccf92d90e4ef84408"
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