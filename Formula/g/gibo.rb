class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https:github.comsimonwhitakergibo"
  url "https:github.comsimonwhitakergiboarchiverefstagsv3.0.10.tar.gz"
  sha256 "0b35e65ec1db30fa0bdb88821e506e8f1ad75cbbcc2324b78a6b8097a593eb9d"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "abb5f334c4755e5abef0bc6bb53981bc572cdbbea4cb308631546f8c42aa115f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00bf8f280699fe46ae6370e94fbdc16dce44d00f9ef55d748d3ed4c832603697"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbf01174e1e2c4f4231f961359905f66e2fae1e93953279ab77b2646841b59f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "bca057eb4427fee82a07ffa04874265c42b1d17e58c5c98480f2d208d68139b6"
    sha256 cellar: :any_skip_relocation, ventura:        "f8bb97cbeecbbb57a58578879ac6bb8956e047ed05673539077df3e8703eb7a7"
    sha256 cellar: :any_skip_relocation, monterey:       "58cdc77691b6c39a255572be39c0b31e7e0ee702d9fe74b2aeee81aeb2d1b229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e721b106b43587b41b0ebe73f6051bfa6b1ee645f9a1cc46a1e013014832886f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comsimonwhitakergibocmd.version=#{version}
      -X github.comsimonwhitakergibocmd.commit=brew
      -X github.comsimonwhitakergibocmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    generate_completions_from_executable(bin"gibo", "completion")
  end

  test do
    system "#{bin}gibo", "update"
    assert_includes shell_output("#{bin}gibo dump Python"), "Python.gitignore"

    assert_match version.to_s, shell_output("#{bin}gibo version")
  end
end