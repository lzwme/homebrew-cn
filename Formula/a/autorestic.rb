class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https:autorestic.vercel.app"
  url "https:github.comcupcakearmyautoresticarchiverefstagsv1.8.3.tar.gz"
  sha256 "2f9ccdb83621530ebda4d22373554af45eeb550d32924a82249dbc66cb867726"
  license "Apache-2.0"
  head "https:github.comcupcakearmyautorestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b08a884dfb153b6fe2127bd30c91ee36aad5622ec69305b13ba23b43d358c351"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b08a884dfb153b6fe2127bd30c91ee36aad5622ec69305b13ba23b43d358c351"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b08a884dfb153b6fe2127bd30c91ee36aad5622ec69305b13ba23b43d358c351"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe4791b279ef81457641763d07a23b02df7aeb2eafa8cd2ceaf72ba1ed9227c9"
    sha256 cellar: :any_skip_relocation, ventura:        "fe4791b279ef81457641763d07a23b02df7aeb2eafa8cd2ceaf72ba1ed9227c9"
    sha256 cellar: :any_skip_relocation, monterey:       "fe4791b279ef81457641763d07a23b02df7aeb2eafa8cd2ceaf72ba1ed9227c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdcc8558f432a2b40971c51191e07ab9b8f21c60e3b8fd959f48a5139a483faa"
  end

  depends_on "go" => :build
  depends_on "restic"

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:), ".main.go"
    generate_completions_from_executable(bin"autorestic", "completion")
  end

  test do
    require "yaml"
    config = {
      "locations" => { "foo" => { "from" => "repo", "to" => ["bar"] } },
      "backends"  => { "bar" => { "type" => "local", "key" => "secret", "path" => "data" } },
    }
    config["version"] = 2

    (testpath".autorestic.yml").write config.to_yaml
    (testpath"repo""test.txt").write("This is a testfile")

    system bin"autorestic", "check"
    system bin"autorestic", "backup", "-a"
    system bin"autorestic", "restore", "-l", "foo", "--to", "restore"
    assert compare_file testpath"repo""test.txt", testpath"restore"testpath"repo""test.txt"
  end
end