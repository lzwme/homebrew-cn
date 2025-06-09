class Nyx < Formula
  include Language::Python::Virtualenv

  desc "Command-line monitor for Tor"
  homepage "https:nyx.torproject.org"
  url "https:files.pythonhosted.orgpackagesf4da68419425cb0f64f996e2150045c7043c2bb61f77b5928c2156c26a21db88nyx-2.1.0.tar.gz"
  sha256 "88521488d1c9052e457b9e66498a4acfaaa3adf3adc5a199892632f129a5390b"
  license "GPL-3.0-only"
  revision 3

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d7b2a2b86698a16d079eaa5f30e5f21fa0dcef3f356f2532fc3eae3bc8353ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d7b2a2b86698a16d079eaa5f30e5f21fa0dcef3f356f2532fc3eae3bc8353ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d7b2a2b86698a16d079eaa5f30e5f21fa0dcef3f356f2532fc3eae3bc8353ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "c01145218094ee9fe66681f2fef001e7f5f12f15f83506626da97b03de4b7d96"
    sha256 cellar: :any_skip_relocation, ventura:       "c01145218094ee9fe66681f2fef001e7f5f12f15f83506626da97b03de4b7d96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e66bd75e96eb2c49a0a6ff381205b7d9639dabda79d2aaa512a4baa7028b224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d7b2a2b86698a16d079eaa5f30e5f21fa0dcef3f356f2532fc3eae3bc8353ef"
  end

  depends_on "python@3.13"

  resource "stem" do
    url "https:files.pythonhosted.orgpackagesb266c5515de764bffae1347e671819711268da5c02bfab8406223526822fe5f6stem-1.8.1.tar.gz"
    sha256 "81d43a7c668ba9d7bc1103b2e7a911e9d148294b373d27a59ae8da79ef7a3e2f"

    # Support python 3.11
    # Fixed upstream in https:github.comtorprojectstemcommitb8063b3b23af95e02b27848f6ab5c82edd644609
    patch :DATA
  end

  # Support python 3.11
  patch do
    url "https:github.comtorprojectnyxcommitdcaddf2ab7f9d2ef8649f98bb6870995ebe0b893.patch?full_index=1"
    sha256 "132cf1c3d4ce6e706cc3ad9dd5cd905d3321c7e62386e18219b4eb08816d6849"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Connection refused", shell_output("#{bin}nyx -i 127.0.0.1:#{free_port}", 1)
  end
end

__END__
diff --git astemcontrol.py bstemcontrol.py
index e192e29..e6fab6c 100644
--- astemcontrol.py
+++ bstemcontrol.py
@@ -474,7 +474,7 @@ def with_default(yields = False):

   def decorator(func):
     def get_default(func, args, kwargs):
-      arg_names = inspect.getargspec(func).args[1:]  # drop 'self'
+      arg_names = inspect.getfullargspec(func).args[1:]  # drop 'self'
       default_position = arg_names.index('default') if 'default' in arg_names else None

       if default_position is not None and default_position < len(args):
diff --git astemprereq.py bstemprereq.py
index 4af6c09..4009c31 100644
--- astemprereq.py
+++ bstemprereq.py
@@ -241,7 +241,7 @@ def is_mock_available():

     # check for mock's new_callable argument for patch() which was introduced in version 0.8.0

-    if 'new_callable' not in inspect.getargspec(mock.patch).args:
+    if 'new_callable' not in inspect.getfullargspec(mock.patch).args:
       raise ImportError()

     return True
diff --git astemutilconf.py bstemutilconf.py
index 8039981..15c4db8 100644
--- astemutilconf.py
+++ bstemutilconf.py
@@ -285,7 +285,7 @@ def uses_settings(handle, path, lazy_load = True):
         config.load(path)
         config._settings_loaded = True

-      if 'config' in inspect.getargspec(func).args:
+      if 'config' in inspect.getfullargspec(func).args:
         return func(*args, config = config, **kwargs)
       else:
         return func(*args, **kwargs)