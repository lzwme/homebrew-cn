class Run < Formula
  desc "Easily manage and invoke small scripts and wrappers"
  homepage "https:github.comTekWizelyrun"
  url "https:github.comTekWizelyrunarchiverefstagsv0.11.2.tar.gz"
  sha256 "942427701caa99a9a3a6458a121b5c80b424752ea8701b26083841de5ae43ff6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac7325643156aa96a729b67c7331bf0567ad3a37681093e79d9b090644de3469"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9047620f1da5c223c4c7aa7ea33861ca346fd33335515a553fb11aa12f9505f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9047620f1da5c223c4c7aa7ea33861ca346fd33335515a553fb11aa12f9505f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9047620f1da5c223c4c7aa7ea33861ca346fd33335515a553fb11aa12f9505f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "c81056e1cf59a6c42ea6e393dc4e146a19a042bb7c0c488bcd6f26dd3f9c9194"
    sha256 cellar: :any_skip_relocation, ventura:        "7b9ad23183cb19b835add35b5e65768ea6bd5295181c03d9ab1372996ff75fcb"
    sha256 cellar: :any_skip_relocation, monterey:       "7b9ad23183cb19b835add35b5e65768ea6bd5295181c03d9ab1372996ff75fcb"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b9ad23183cb19b835add35b5e65768ea6bd5295181c03d9ab1372996ff75fcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab579ac93d7c9474a761d9b51e1fb347119b8f990af87d0bcd03043aa388dbe8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    text = "Hello Homebrew!"
    task = "hello"
    (testpath"Runfile").write <<~EOS
      #{task}:
        echo #{text}
    EOS
    assert_equal text, shell_output("#{bin}#{name} #{task}").chomp
  end
end