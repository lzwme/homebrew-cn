class Chkbit < Formula
  desc "Check your files for data corruption"
  homepage "https:github.comlaktakchkbit"
  url "https:github.comlaktakchkbitarchiverefstagsv5.3.0.tar.gz"
  sha256 "70c7800cf92245a8b76ad5485bbe299251ce1dc7894873a8ab198712ab407c41"
  license "MIT"
  head "https:github.comlaktakchkbit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7beb4e1287bd9e353d88ea6382bd1da7626789e3cab128dcadc95bb5ca599fa1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7beb4e1287bd9e353d88ea6382bd1da7626789e3cab128dcadc95bb5ca599fa1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7beb4e1287bd9e353d88ea6382bd1da7626789e3cab128dcadc95bb5ca599fa1"
    sha256 cellar: :any_skip_relocation, sonoma:        "66e10e990ce4c166674ae01ac20dcbf4e023efd52cd640ac9bcd7a8d7c7ff3ca"
    sha256 cellar: :any_skip_relocation, ventura:       "66e10e990ce4c166674ae01ac20dcbf4e023efd52cd640ac9bcd7a8d7c7ff3ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3002b57bbd6b83bb1dc5e06a2eb0585ec87aefd3496fec983775a1c3cfa7b178"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.appVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdchkbit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chkbit --version").chomp

    (testpath"one.txt").write <<~EOS
      testing
      testing
      testing
    EOS

    system bin"chkbit", "-u", testpath
    assert_predicate testpath".chkbit", :exist?
  end
end