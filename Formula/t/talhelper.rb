class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv3.0.18.tar.gz"
  sha256 "d05165c0a25c6ea6dc95c6ff1cb2d143ce172eb089b39512a0b842f22dd518dd"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18fb63db1da3fdbcdbe50a2c9f0cd2588874d5cf5f968ddc5047b0c9222d9cdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18fb63db1da3fdbcdbe50a2c9f0cd2588874d5cf5f968ddc5047b0c9222d9cdd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18fb63db1da3fdbcdbe50a2c9f0cd2588874d5cf5f968ddc5047b0c9222d9cdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "3896a4828052b6414768057556404bcbdf8a0cf41119755266d9644d51e8357b"
    sha256 cellar: :any_skip_relocation, ventura:       "3896a4828052b6414768057556404bcbdf8a0cf41119755266d9644d51e8357b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c16073f2c9b43122ad43323322cc25564a0ee8d6a725a538f793784828c29220"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combudimanjojotalhelperv#{version.major}cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}example*"], testpath

    output = shell_output("#{bin}talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}talhelper --version")
  end
end