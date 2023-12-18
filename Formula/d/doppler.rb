class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https:docs.doppler.comdocs"
  url "https:github.comDopplerHQcliarchiverefstags3.66.5.tar.gz"
  sha256 "cd4f8cea2685d286859851f95043506121c05098a7be506e2b6664a42e217e37"
  license "Apache-2.0"
  head "https:github.comDopplerHQcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "689515a3f387e88824f1a128526c6762f79eaae34271ac52e6ff6f1b6200d856"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6740df7572ee17897db18144d2052b6610a706d0dc75b7d62787faeea89a0242"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7988f93753baa2b5c2eb82077530d7c40b98b2fa63a5ec4e43247f6035848bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ac1e0d5ecf2b755924d8f716cf4688285167d73ef5da637b043295211a8caaf"
    sha256 cellar: :any_skip_relocation, ventura:        "fbc113a0588295afb1d8a36cdff8bafff8275707a61498722584716bb5072c8d"
    sha256 cellar: :any_skip_relocation, monterey:       "a2e42fc6a00a5ff39ff4a51da6fd8710478de62cf8d76e9abe3a81fbd7fd3d2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f00b10cfd268e5bc838d30c5e82f12367ebb36606b2922d67142088b74e97c2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comDopplerHQclipkgversion.ProgramVersion=dev-#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin"doppler", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}doppler --version")

    output = shell_output("#{bin}doppler setup 2>&1", 1)
    assert_match "Doppler Error: you must provide a token", output
  end
end