class Snakeviz < Formula
  include Language::Python::Virtualenv

  desc "Web-based viewer for Python profiler output"
  homepage "https://jiffyclub.github.io/snakeviz/"
  url "https://files.pythonhosted.org/packages/04/06/82f56563b16d33c2586ac2615a3034a83a4ff1969b84c8d79339e5d07d73/snakeviz-2.2.2.tar.gz"
  sha256 "08028c6f8e34a032ff14757a38424770abb8662fb2818985aeea0d9bc13a7d83"
  license "BSD-3-Clause"
  revision 6

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b4c0c3c87c072ec31a551feecd390d41641f400c3b9cfa0c827a1a8f3a179d1b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1f21a1bebd839288fe39da1a1ff2338ad2bd2b2724ef300abac26235bdb7b993"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c145df4b3d141ee54776efb5212f6345077ed4fb6f8a0857b8cfc27937e57711"
    sha256 cellar: :any,                 arm64_linux:       "ee03539e1b52976da849941b179d521dc9986d485255714b1192de24d7d63d64"
    sha256 cellar: :any,                 x86_64_linux:      "5152bf8b95a69daef77283201211ea5452adece99b856c9136491a245a828823"
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
    require "cgi"
    system bin/"snakeviz", "--version"
    system python3, "-m", "cProfile", "-o", "output.prof", "-m", "cProfile"

    port = free_port

    output_file = testpath/"output.prof"

    pid = fork do
      exec bin/"snakeviz", "--port", port.to_s, "--server", output_file
    end
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/snakeviz/#{ERB::Util.url_encode output_file}")
    assert_match "cProfile", output
  ensure
    Process.kill("HUP", pid)
  end
end