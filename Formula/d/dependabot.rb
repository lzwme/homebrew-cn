class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https:github.comdependabotcli"
  url "https:github.comdependabotcliarchiverefstagsv1.63.0.tar.gz"
  sha256 "0c8296efdcdead61b903efa794bcf6e8f296106c79b61adc131968636997f63a"
  license "MIT"
  head "https:github.comdependabotcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88c82cf79cf06d85dd7b4cba5060ae8a205b911d587a56f1c4db371c9de94a04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88c82cf79cf06d85dd7b4cba5060ae8a205b911d587a56f1c4db371c9de94a04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88c82cf79cf06d85dd7b4cba5060ae8a205b911d587a56f1c4db371c9de94a04"
    sha256 cellar: :any_skip_relocation, sonoma:        "e41b12a2aadd7a93f1d594c43161306ed1194ffcfc8c51a64d87b57b363b3aa9"
    sha256 cellar: :any_skip_relocation, ventura:       "e41b12a2aadd7a93f1d594c43161306ed1194ffcfc8c51a64d87b57b363b3aa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5104f3e4c770b8af07e801f027dcd9ca66448c17c052b568949071e34b6beb4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comdependabotclicmddependabotinternalcmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmddependabot"

    generate_completions_from_executable(bin"dependabot", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix:#{testpath}invalid.sock"
    assert_match("dependabot version #{version}", shell_output("#{bin}dependabot --version"))
    output = shell_output("#{bin}dependabot update bundler Homebrewhomebrew 2>&1", 1)
    assert_match("Cannot connect to the Docker daemon", output)
  end
end