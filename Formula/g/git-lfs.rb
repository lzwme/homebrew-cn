class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https:git-lfs.github.com"
  url "https:github.comgit-lfsgit-lfsreleasesdownloadv3.6.0git-lfs-v3.6.0.tar.gz"
  sha256 "9a5d2a598b4096f0fdde5b2ead6038996c657acafe5a89d22b8c2f1b56aeaf36"
  license "MIT"

  # Upstream creates releases that are sometimes not the latest stable version,
  # so we use the `github_latest` strategy to fetch the release tagged as "latest".
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89ebf5b724d04b05d8bfbb30f3f7def31b858f907dbea09f8fb45be8971aa3a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89ebf5b724d04b05d8bfbb30f3f7def31b858f907dbea09f8fb45be8971aa3a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89ebf5b724d04b05d8bfbb30f3f7def31b858f907dbea09f8fb45be8971aa3a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9843027dbca6884d5e4f6894534dbc4c52d59ae33580c4fff4fb29c0b8f7a7f"
    sha256 cellar: :any_skip_relocation, ventura:       "e9843027dbca6884d5e4f6894534dbc4c52d59ae33580c4fff4fb29c0b8f7a7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c40bb62ad209374aec8b93c4ec19724fc4b99c15bd2e7429a473ecfdf3105dd1"
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build

  def install
    ENV["GIT_LFS_SHA"] = ""
    ENV["VERSION"] = version

    system "make"
    system "make", "man"

    bin.install "bingit-lfs"
    man1.install Dir["manman1*.1"]
    man5.install Dir["manman5*.5"]
    man7.install Dir["manman7*.7"]
    doc.install Dir["manhtml*.html"]
    generate_completions_from_executable(bin"git-lfs", "completion")
  end

  def caveats
    <<~EOS
      Update your git config to finish installation:

        # Update global git config
        $ git lfs install

        # Update system git config
        $ git lfs install --system
    EOS
  end

  test do
    system "git", "init"
    system "git", "lfs", "track", "test"
    assert_match(^test filter=lfs, File.read(".gitattributes"))
  end
end