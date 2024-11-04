class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https:ytdl-org.github.ioyoutube-dl"
  license "Unlicense"

  stable do
    url "https:files.pythonhosted.orgpackages014fab0d0806f4d818168d0ec833df14078c9d1ddddb5c42fa7bfb6f15ecbfa7youtube_dl-2021.12.17.tar.gz"
    sha256 "bc59e86c5d15d887ac590454511f08ce2c47698d5a82c27bfe27b5d814bbaed2"

    # Backport fix for extractor handling consent
    patch do
      url "https:github.comytdl-orgyoutube-dlcommitaaed4884ed9954b8b69c3ca5254418ec578ed0b9.patch?full_index=1"
      sha256 "3078402768839f4ad611bcb7ab3b221d1a97626c62c4f1bdb2f85598fa45fa96"
    end
  end

  bottle do
    rebuild 5
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f3b77e4e5dc244e6e1e85f307083798af83134824e30977936acedf014b58cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f3b77e4e5dc244e6e1e85f307083798af83134824e30977936acedf014b58cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f3b77e4e5dc244e6e1e85f307083798af83134824e30977936acedf014b58cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "71f792a632398bd152e07f7f46b36b841de4687915c9a4cd502b3d3893e35562"
    sha256 cellar: :any_skip_relocation, ventura:       "71f792a632398bd152e07f7f46b36b841de4687915c9a4cd502b3d3893e35562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f3b77e4e5dc244e6e1e85f307083798af83134824e30977936acedf014b58cc"
  end

  head do
    url "https:github.comytdl-orgyoutube-dl.git", branch: "master"
    depends_on "pandoc" => :build
  end

  # https:github.comytdl-orgyoutube-dlissues31585
  # https:github.comytdl-orgyoutube-dlissues31067
  disable! date: "2024-11-23", because: "has a failing test since forever and no new release since 2021"

  depends_on "python@3.13"

  def install
    python3 = which("python3.13")
    if build.head?
      system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "PYTHON=#{python3}", "install"
      fish_completion.install prefix"etcfishcompletionsyoutube-dl.fish"
      rm_r(prefix"etcfish")
    else
      virtualenv_install_with_resources
      # Handle "ERROR: Unable to extract uploader id" until new release
      # https:github.comytdl-orgyoutube-dlissues31530
      inreplace libexecLanguage::Python.site_packages(python3)"youtube_dlextractoryoutube.py",
                "owner_profile_url, 'uploader id')",
                "owner_profile_url, 'uploader id', fatal=False)"
      man1.install_symlink libexec"sharemanman1youtube-dl.1" => "youtube-dl.1"
      bash_completion.install libexec"etcbash_completion.dyoutube-dl.bash-completion"
      fish_completion.install libexec"etcfishcompletionsyoutube-dl.fish"
    end
  end

  def caveats
    <<~EOS
      The current youtube-dl version has many unresolved issues.
      Upstream have not tagged a new release since 2021.

      Please use yt-dlp instead.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}youtube-dl --version")

    # Tests fail with bot detection
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # commit history of homebrew-core repo
    system bin"youtube-dl", "--simulate", "https:www.youtube.comwatch?v=pOtd1cbOP7k"
    # homebrew playlist
    system bin"youtube-dl", "--simulate", "--yes-playlist", "https:www.youtube.comwatch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end