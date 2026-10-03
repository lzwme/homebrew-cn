class Livereload < Formula
  include Language::Python::Virtualenv

  desc "Local web server in Python"
  homepage "https://livereload.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/43/6e/f2748665839812a9bbe5c75d3f983edbf3ab05fa5cd2f7c2f36fffdf65bd/livereload-2.7.1.tar.gz"
  sha256 "3d9bf7c05673df06e32bea23b494b8d36ca6d10f7d5c3c8a6989608c09c986a9"
  license "BSD-3-Clause"
  revision 4

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "77dc6ee3ada2a0b47448a9af44669413f58e8525071532ac6f99f2e49822911e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "15aeb1318a37dab72f3aac01d20db588a8eb31ff819c54e6d1dddb3c85d1d89e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1367d1f126fa4bd4bfd435f360e0239578b9a7e71f044979c5b265272da802ae"
    sha256 cellar: :any,                 arm64_linux:       "13e2f4ca25f0bc4f3a2040170be4b877593ef579c4494e20563d549839103cd4"
    sha256 cellar: :any,                 x86_64_linux:      "01625e5f67bda053d0c9dd062465f1bd58241df1f028e9ab46c7d0222b3a8ee7"
  end

  depends_on "python@3.14"

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/06/61/53d562a57b28c08eda40b258c0f975e360541943ad7c7bef897a40caafda/tornado-6.5.10.tar.gz"
    sha256 "a6b1ccd08c04b4a06fb5aeb381be99de5ad1e5375c1785e31d78c880feb57687"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"index.html").write <<~HTML
      <h1>Hello, world!</h1>
    HTML

    port = free_port
    pid = spawn bin/"livereload", testpath, "--port=#{port}"

    begin
      sleep 5
      output = shell_output("curl --retry 5 --retry-connrefused -s http://localhost:#{port}/index.html")
      assert_match "<h1>Hello, world!</h1>", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end