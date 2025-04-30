class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.35.2.tar.gz"
  sha256 "0093e5192af8e575b2c204ad7fc449373fb118fcee7ebf246432d0976c73ab2d"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16dc5ed490a1a50f6f24cfc6caff878b0c7e265b8699f2f2a11acf83b68ccd5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d390c10d549498e747a11b57fc8705b042dcc65d4575db763f56394074503baa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6da499ec101536c71f83616ee364ca49923ecd8ca2d7d47ba99a24bc1cd7db38"
    sha256 cellar: :any_skip_relocation, sonoma:        "de7bdb405b01b306a613566fbf00f3e0c98732166a75e6cdcd15dc3d8c33b666"
    sha256 cellar: :any_skip_relocation, ventura:       "b670b3f60ea4dfd395c3d4fa6aa3741ec79bb667356ea67b3b28e4db016c81b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ce38dea60d6147bb0638a4fc4cd138e23cbf5a3d01672ddfcc2bbf2f1d72afa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "097722e4d068659b6dede46001db0423680c609d83c90cdf23ebefa709bd02a7"
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