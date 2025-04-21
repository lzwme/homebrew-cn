class Tailspin < Formula
  desc "Log file highlighter"
  homepage "https:github.combensadehtailspin"
  url "https:github.combensadehtailspinarchiverefstags5.4.1.tar.gz"
  sha256 "8f57c87aaf02f4b5287066bb19da0dbc791a88cfa0a2c2de16af2d49269b2f1c"
  license "MIT"
  head "https:github.combensadehtailspin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53881f1cf3d498767a37412a1fe5e3e85eb855d45b9bba2243f70d36cf9fd3b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5bdeb0fde3a915106b497108ba695090b6faa78272fb95e7d374ed1dec3af4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6bcecf1e102ebd86db1e106adef67c02a51654269b76213fddb601ba0e54e5e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b1459797a7d7b1b7bf2afd7cc942aeafb866d0c3a0f17b42e23e0d4ecb9fb6c"
    sha256 cellar: :any_skip_relocation, ventura:       "b55bb86ee91dbc3f8417fed1c2980f93e23f980c41ede095bf67861ec6029590"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70854cbfc380b355f0df846630ea7cfa6fc66e0cc5cff5fe8cfd144478792773"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d31bd9af6488d6062e49d9c1cc2231724e42a1d9db4fda119b257197e4ee278"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completionstspin.bash" => "tspin"
    fish_completion.install "completionstspin.fish"
    zsh_completion.install "completionstspin.zsh" => "_tspin"
    man1.install "mantspin.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tspin --version")

    (testpath"test.log").write("test\n")
    system bin"tspin", "test.log"
  end
end