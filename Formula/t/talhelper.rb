class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv3.0.15.tar.gz"
  sha256 "f30a90c908bdaf0d338b02673c5b8dc0a083435729bd5124efe659ce2e661488"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6f30a82a7e7a371ae1f07456c397ecc50f7945b790202c24d5662fd4d7b0a43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6f30a82a7e7a371ae1f07456c397ecc50f7945b790202c24d5662fd4d7b0a43"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d6f30a82a7e7a371ae1f07456c397ecc50f7945b790202c24d5662fd4d7b0a43"
    sha256 cellar: :any_skip_relocation, sonoma:        "a807e4a72ddff0bf3885895f896d66f8f37d7c65571afce904728dfd7e3915ab"
    sha256 cellar: :any_skip_relocation, ventura:       "a807e4a72ddff0bf3885895f896d66f8f37d7c65571afce904728dfd7e3915ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95451fe5412f81b6d427514c9b07a9927fb0129b406072272a55dab93488c5b4"
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