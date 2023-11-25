class Risor < Formula
  desc "Fast and flexible scripting for Go developers and DevOps"
  homepage "https://risor.io/"
  url "https://ghproxy.com/https://github.com/risor-io/risor/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "7c7db6096bed26aef4726995bd5b2f9872238ca7fef434991c9fb2c11d3e694f"
  license "Apache-2.0"
  head "https://github.com/risor-io/risor.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "971bfcd2b34f88661305b403cbc9a03f72d6d606fc9f691c7638c078ac6fa4d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b34c098d8c4654e8a1ad354aca3c051014bec63b009258ffb201062526e045c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f941151a423fb58263f7c1e78c1ffaaa2ef5fc313193486015021de8317678e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "8eb1f9c7dd36a974ce14686cb69af46543bac44f530a77ead064227be3fabfff"
    sha256 cellar: :any_skip_relocation, ventura:        "fb3b177504d0f21e1c1fd48bbd000b400c6d72f2cb880bfdd31974ded20999f3"
    sha256 cellar: :any_skip_relocation, monterey:       "f8b4f530345f1478bbb5538d7c2927e5ff540c728abb17379f1392d4fb4b3df6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08ddaa32c10c8ab443639abf35250bfd47da3ce5a786fd58f455a9164bd5b0b3"
  end

  depends_on "go" => :build

  def install
    chdir "cmd/risor" do
      ldflags = "-s -w -X 'main.version=#{version}' -X 'main.date=#{time.iso8601}'"
      system "go", "build", "-tags", "aws", *std_go_args(ldflags: ldflags), "."
      generate_completions_from_executable(bin/"risor", "completion")
    end
  end

  test do
    output = shell_output("#{bin}/risor -c \"time.now()\"")
    assert_match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/, output)
    assert_match version.to_s, shell_output("#{bin}/risor version")
    assert_match "module(aws)", shell_output("#{bin}/risor -c aws")
  end
end