class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "a989178d52caf4500a4e9dff426390804c9b59dda95a8187e99b765844f863f2"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4f225334550a92ed6e3727304cc18efc83184d3376b9e05397070f246d544f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05f0f34a46ca6813b5bdbc672bd5ea3fe94c60c25b7def74d39874123895337a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb1eab871a18bec0e2016c14364c0b1e2415d4a4cf78bf9d8df5296d2b0ebb73"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf95ef0a93bb2edf9c4724f2e3bbf80b259820fb81b339e4a57ea5e81819f5c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b93c6c87b39198a08de8db1fd3f4d117a14572fbc1dfbcd3710f726980f694d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b613fd02f96b294db799b902c1ea9717a58e589b714011947e6e228c13f3f2f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/nono-cli")
  end

  test do
    ENV["NONO_NO_UPDATE_CHECK"] = "1"

    assert_match version.to_s, shell_output("#{bin}/nono --version")

    other_dir = testpath/"other"
    other_file = other_dir/"allowed.txt"
    other_dir.mkpath
    other_file.write("nono")

    output = shell_output("#{bin}/nono --silent why --json --path #{other_file} --op write --allow #{other_dir}")
    assert_match "\"status\": \"allowed\"", output
    assert_match "\"reason\": \"granted_path\"", output
  end
end